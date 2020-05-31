'use strict';

const { sanitizeEntity } = require('strapi-utils');

/**
 * Read the documentation (https://strapi.io/documentation/3.0.0-beta.x/concepts/controllers.html#core-controllers)
 * to customize this controller
 */

module.exports = {

  async update(ctx) {
    const { id } = ctx.params;
    let entity;

    const { products } = ctx.request.body;
    entity = await strapi.services.cart.update({ id }, { products: JSON.parse(products) });

    return sanitizeEntity(entity, { model: strapi.models.cart });
  }
};
