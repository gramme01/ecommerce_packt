'use strict';
require('dotenv').config();
// const axios = require('axios');
const stripe = require('stripe')(`${process.env.STRIPE_TEST}`);

/**
 * A set of functions called "actions" for `card`
 */

module.exports = {
  // exampleAction: async (ctx, next) => {
  //   try {
  //     ctx.body = 'ok';
  //   } catch (err) {
  //     ctx.body = err;
  //   }
  // }

  async index(ctx) {
    // ctx.send('hello world');
    const customerId = ctx.request.querystring;
    console.log(customerId);
    const customerData = await stripe.customers.retrieve(customerId);
    const cardData = customerData.sources.data;
    console.log(cardData);
    ctx.send(cardData);
  },

  async add(ctx) {
    const { customer, source } = ctx.request.body;
    const card = await stripe.paymentMethods.attach(source, { customer });
    // const card = await stripe.customers.createSource(customer, { source });
    ctx.send(card);
    // ctx.send('sent')
  }
};
