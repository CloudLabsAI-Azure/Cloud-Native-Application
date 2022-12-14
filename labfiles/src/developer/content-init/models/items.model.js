'use strict';

var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var itemsSchema = new Schema({
    _id: {
        type: String
    },
    bio: {
        type: String
    },
    company: {
        type: String
    },
    first: {
        type: String
    },
    hidden: {
        type: Boolean
    },
    inShow: {
        type: String
    },
    last: {
        type: String
    },
    photo: {
        type: String
    },
    sessions: [{
        type: String
    }],
    sessionscodes: [{
        type: String
    }],
    speakerID: {
        type: Number
    },
    title: {
        type: String
    },
    tracks: [{
        type: String
    }]
});

module.exports = mongoose.model('items', itemsSchema);