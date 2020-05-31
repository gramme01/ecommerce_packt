"use strict";
require("dotenv").config();
const stripe = require("stripe")(`${process.env.STRIPE_TEST}`);
const { v4: uuidv4 } = require("uuid");

/**
 * Read the documentation (https://strapi.io/documentation/3.0.0-beta.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

const { sanitizeEntity } = require("strapi-utils");

module.exports = {
  async create(ctx) {
    let entity;
    const { amount, products, customer, paymentMethod } = ctx.request.body;
    const { email } = ctx.state.user;
    const charge = {
      amount: Number(amount) * 100,
      currency: "usd",
      customer,
      paymentMethod,
      receipt_email: email,
    };
    const idempotencyKey = uuidv4();

    await stripe.charges.create(charge, {
      idempotencyKey,
    });

    entity = await strapi.services.order.create({
      amount,
      products: JSON.parse(products),
      user: ctx.state.user,
    });

    return sanitizeEntity(entity, { model: strapi.models.order });
  },
};
