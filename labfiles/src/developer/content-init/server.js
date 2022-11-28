const mongoose = require('mongoose');
const config = require('./config/config');
const chalk = require('chalk');
const async = require('async');

mongoose.connect(config.appSettings.db, { useNewUrlParser: true, useUnifiedTopology: true }, function (err) {
    if (err) {
        console.error(chalk.red('Could not connect to MongoDB!'));
        console.log(chalk.red(err));
        mongoose.connection.close();
        process.exit(-1);
    } else {
        console.log('Connected to MongoDb');
    }
});

require('./models/product.model');
const product = mongoose.model('product');

require('./models/items.model');
const items = mongoose.model('items');

async.waterfall([
    function (callback) {
        console.log('Clean products table');
        product.remove({}, function (err) {
            if (err) {
                callback(err);
            } else {
                console.log(chalk.green('All products deleted'));
                callback(null);
            }
        })
    },
    function (callback) {
        console.log('Load products from JSON file');
        const productsTemplate = require('./json/products');
        const createproduct = function (object, itemCallback) {
            const product = new product(object);
            product.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('product saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(productsTemplate, createproduct, callback)
    },
    function (callback) {
        console.log('Clean items table');
        items.remove({}, function (err) {
            if (err) {
                callback(err);
            } else {
                console.log(chalk.green('All items deleted'));
                callback(null);
            }
        });
    },
    function (callback) {
        console.log('Load items from JSON file');
        const itemsTemplate = require('./json/items');
        const createitems = function (object, itemCallback) {
            const items = new items(object);
            items.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('items saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(itemsTemplate, createitems, callback)
    }
], function (err) {
    if (err) {
        console.error(chalk.red(err));
    }
    mongoose.connection.close();
});