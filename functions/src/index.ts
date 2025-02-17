import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import Stripe from 'stripe';

admin.initializeApp();
const stripe = new Stripe('sk_test_51PSfNKP4bUyQSoutcUSXX8FRfUAUys3M4URkCCNuWXgCM2V17m05KX6cQBc4ZRklzYB9Y5SbmUBTEVsOgmwaMS5t00msUVVAyE', { apiVersion: '2025-01-27.acacia' });

export const createPaymentIntent = functions.https.onCall(async (data, context) => {
    try {
        const amount = data.amount;

        const paymentIntent = await stripe.paymentIntents.create({
            amount: amount * 100,
            currency: 'mdl',
            payment_method_types: ['card'],
        });

        return {
            clientSecret: paymentIntent.client_secret,
        };
    } catch (error) {
        if (error instanceof Error) {
            console.error('Stripe Error:', error.message);
            throw new functions.https.HttpsError('internal', error.message);
        } else {
            console.error('Unknown Error:', error);
            throw new functions.https.HttpsError('internal', 'An unknown error occurred');
        }
    }
});
