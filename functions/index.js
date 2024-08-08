const functions = require("firebase-functions");

const {
  RtcTokenBuilder,
  RtcRole,
} = require("agora-token");

exports.generateToken = functions.https.onCall(async (data, context) => {
  const appId = data.appId;
  const appCertificate = data.appCertificate;
  const channelName = Math.floor(Math.random() * 100).toString();
  const uid = 0;
  const role = RtcRole.PUBLISHER;

  const expirationTimeInSeconds = 36000;
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

  if (channelName === undefined || channelName === null) {
    throw new functions.https.HttpsError(
        "aborted",
        "Channel name is required",
    );
  }

  try {
    const token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        role,
        privilegeExpiredTs,
    );

    return {
      data: {
        token: token,
        channelName: channelName,
      },
    };
  } catch (err) {
    throw new functions.https.HttpsError(
        "aborted",
        "Could not generate token",
    );
  }
});


