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
        console.log('Clean product table');
        Session.remove({}, function (err) {
            if (err) {
                callback(err);
            } else {
                console.log(chalk.green('All product deleted'));
                callback(null);
            }
        })
    },
    function (callback) {
        console.log('Load product from JSON file');
        const sessionsTemplate = require('./json/product');
        const createSession = function (object, itemCallback) {
            const session = new Session(object);
            session.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('product saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(sessionsTemplate, createSession, callback)
    },
    function (callback) {
        console.log('Clean items table');
        Speaker.remove({}, function (err) {
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
        const speakersTemplate = require('./json/items');
        const createSpeaker = function (object, itemCallback) {
            const speaker = new Speaker(object);
            speaker.save(function (err) {
                if (err) {
                    itemCallback(err);
                } else {
                    console.log(chalk.green('items saved successfully'));
                    itemCallback(null);
                }
            });
        };
        async.each(speakersTemplate, createSpeaker, callback)
    }
], function (err) {
    if (err) {
        console.error(chalk.red(err));
    }
    mongoose.connection.close();
});