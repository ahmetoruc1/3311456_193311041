
const {logger} = require("firebase-functions");
const {onRequest} = require("firebase-functions/v2/https");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");

const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const functions = require('firebase-functions');
const admin = require('firebase-admin');



admin.initializeApp();



exports.takipGerceklesti = functions.firestore.document('takipciler/{takipEdilenId}/KullanicininTakipcileri/{takipEdenKullaniciId}').onCreate(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenId;
    const takipEdenId = context.params.takipEdenKullaniciId;

   const gonderilerSnapshot = await admin.firestore().collection("gonderiler").doc(takipEdilenId).collection("KullaniciGonderileri").get();

   gonderilerSnapshot.forEach((doc)=>{
        if(doc.exists){
            const gonderiId = doc.id;
            const gonderiData = doc.data();

            admin.firestore().collection("akislar").doc(takipEdenId).collection("kullaniciAkisGonderileri").doc(gonderiId).set(gonderiData);
        }
   });
});

exports.takiptenCikildi = functions.firestore.document('takipciler/{takipEdilenId}/KullanicininTakipcileri/{takipEdenKullaniciId}').onDelete(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenId;
    const takipEdenId = context.params.takipEdenKullaniciId;

   const gonderilerSnapshot = await admin.firestore().collection("akislar").doc(takipEdenId).collection("kullaniciAkisGonderileri").where("yayinlayanId","==",takipEdilenId).get();

   gonderilerSnapshot.forEach((doc)=>{
        if(doc.exists){
            doc.ref.delete();
        }
   });
});

exports.yeniGonderiEklendi = functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/KullaniciGonderileri/{gonderiId}').onCreate(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiId = context.params.gonderiId;
    const yeniGonderiData = snapshot.data();

    const takipcilerSnapshot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("KullanicininTakipcileri").get();

    takipcilerSnapshot.forEach(doc=>{
        const takipciId = doc.id;
        admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).set(yeniGonderiData);
        console.log(snapshot.data());
    });
});

exports.gonderiGuncellendi = functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/KullaniciGonderileri/{gonderiId}').onUpdate(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiId = context.params.gonderiId;
    const guncellenmisGonderiData = snapshot.after.data();

    const takipcilerSnapshot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("KullanicininTakipcileri").get();

    takipcilerSnapshot.forEach(doc=>{
        const takipciId = doc.id;
        admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).update(guncellenmisGonderiData);

    });
});



/*
exports.yeniGonderiEklendi = functions.firestore.document('gonderiler/{takipEdilenKullaniciId}/KullaniciGonderileri/{gonderiId}').onCreate(async (snapshot, context) => {
    const takipEdilenId = context.params.takipEdilenKullaniciId;
    const gonderiID = context.params.gonderiId;
    const yeniGonderiData=snapshot.data();

    const takipcilerSnapshot = await admin.firestore().collection("takipciler").doc(takipEdilenId).collection("KullanıcınınTakipcileri").get();

   takipcilerSnapshot.forEach((doc)=>{
   const takipciId=doc.id;

   admin.firestore().collection("akislar").doc(takipciId).collection("kullaniciAkisGonderileri").doc(gonderiId).set(yeniGonderiData);
   });

});
*/



