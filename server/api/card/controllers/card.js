'use strict';
require('dotenv').config();
// const axios = require('axios');
const stripe = require('stripe')(`${process.env.STRIPE_TEST}`);

/**
 * A set of functions called "actions" for `card`
 */

module.exports = {
  async index(ctx) {
    const customer = ctx.request.querystring;
    const paymentMethods = await stripe.paymentMethods.list({ customer, type: 'card' });
    const cardData = paymentMethods.data;
    ctx.send(cardData);
  },

  async add(ctx) {
    const { customer, paymentMethodId } = ctx.request.body;
    const paymentMethod = await stripe.paymentMethods.attach(paymentMethodId, { customer });
    console.log(paymentMethod);
    ctx.send(paymentMethod);
  }
};
