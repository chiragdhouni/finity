"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getNotificationsForIds = void 0;
const notification_1 = require("../models/notification");
const getNotificationsForIds = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const notificationIds = req.body.notificationIds; // Ensure you're passing 'notificationIds' in the request body
        const notifications = yield notification_1.Notification.find({ _id: { $in: notificationIds } })
            .sort({ createdAt: -1 })
            .exec();
        return res.status(200).json(notifications);
    }
    catch (err) {
        console.error('Error fetching notifications:', err);
        return res.status(500).json({ error: 'Error fetching notifications' });
    }
});
exports.getNotificationsForIds = getNotificationsForIds;
