
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const functions = require('firebase-functions');
const admin = require('firebase-admin');



admin.initializeApp();


exports.gunlukEkle = functions.firestore.document('deneme/{docId}').onCreate((snapshot, context) => {
  admin.firestore().collection("gunluk").add({
  "aciklama": "Yeni kayıt Girildi."
  });
});


