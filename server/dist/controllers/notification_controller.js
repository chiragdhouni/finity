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
exports.getUserNotifications = void 0;
const notification_1 = require("../models/notification");
const getUserNotifications = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        if (!req.user) {
            return res.status(401).json({ msg: 'Unauthorized: User not found' });
        }
        const userId = req.user.id;
        const notifications = yield notification_1.Notification.find({ userId })
            .sort({ createdAt: -1 })
            .exec();
        res.status(200).json(notifications);
    }
    catch (err) {
        res.status(500).json({ error: 'Error fetching notifications', details: err });
    }
});
exports.getUserNotifications = getUserNotifications;
