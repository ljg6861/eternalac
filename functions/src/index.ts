import * as functions from "firebase-functions";
import * as admin from 'firebase-admin';

//firebase messaging and firestore references
const fcm = admin.messaging();

 exports.newSubscriberNotification = functions.firestore
        .document('messages/{messageId}')
        .onCreate((snap, context) => {

          //You get the values of the newly created doc as follows:
          const docData = snap.data();
          console.log(docData);
          const listedUsers = context.params.to;

            const payload = {
            			data: { documentId: messageDoc.id },
            			notification: {
            				title: 'New Message',
            				body: 'You received a new message!',
            				clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            			},
            		};
          for (const user in listedUsers){
            const tokenDocRef = db.collection('users').doc(user).token;
            const response = await fcm.sendToDevice(tokenDocRef, payload);
          }

          //You get the parameters as follows:
          const userId = context.params.from;

          //console.log(userId);

          const docId = context.params.docId;
          //console.log(docId);

          // You perform here the notification sending
        });
