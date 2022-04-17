import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// firebase messaging and firestore references
const fcm = admin.messaging();
const db = admin.firestore();

export const onMessageCreated = functions.firestore
    .document("messages/{messageId}")
    .onCreate(async (snap, context) => {
      // You get the values of the newly created doc as follows:
      const docData = snap.data();
      console.log(docData);
      console.log(context);
      const listedUsers = snap.data()["to"];

      const payload = {
        notification: {
          title: "New Message",
          body: "You received a new message!",
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      };
      for (let i = 0; i < listedUsers.length; i++) {
        const user = listedUsers[i];
        console.log(user);
        const userDoc = await db.collection("users").doc(user).get();
        const tokenDocRef = userDoc?.data()?.token;
        const response = await fcm.sendToDevice(tokenDocRef, payload);
        console.log(response.toString());
      }
    });
