// worker.js
var MAX_BYTES = 4 * 1024 * 1024;
var worker_default = {
  async email(message, env, ctx) {
    const to = (message.to || "").toLowerCase();
    const domain = "ffilt.us";
    if (!to.endsWith("@" + domain)) {
      message.setReject("recipient domain not accepted");
      return;
    }
    const raw = await new Response(message.raw).arrayBuffer();
    if (raw.byteLength > MAX_BYTES) {
      message.setReject("message too large");
      return;
    }
    const guid = crypto.randomUUID();
    const from = (message.from || "").toLowerCase();
    const subject = message.headers.get("subject") || "";
    await env.RAW_BUCKET.put(guid + ".eml", raw, {
      httpMetadata: { contentType: "message/rfc822" }
    });
    await env.EMAIL_QUEUE.send({
      guid,
      to,
      from,
      subject: subject.slice(0, 256),
      date: message.headers.get("date") || ""
    });
  }
};
export {
  worker_default as default
};
//# sourceMappingURL=worker.js.map
