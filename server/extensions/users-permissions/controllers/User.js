'use strict';

/**
 * User.js controller
 *
 * @description: A set of functions called "actions" for managing `User`.
 */

const _ = require('lodash');
const { sanitizeEntity } = require('strapi-utils');

const sanitizeUser = user =>
  sanitizeEntity(user, {
    model: strapi.query('user', 'users-permissions').model,
  });

const formatError = error => [
  { messages: [{ id: error.id, message: error.message, field: error.field }] },
];

module.exports = {
  async update(ctx) {
    const { id } = ctx.params;

    const { card_token } = ctx.request.body;

    if (_.has(ctx.request.body, 'card_token') && !card_token) {
      return ctx.badRequest('card_token.notNull');
    }


    let updateData = {
      ...ctx.request.body,
    };

    console.log(updateData);

    const data = await strapi.plugins['users-permissions'].services.user.edit({ id }, updateData);
    console.log(data);

    ctx.send(sanitizeUser(data));
  },
}