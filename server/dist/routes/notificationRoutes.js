"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const notification_controller_1 = require("../controllers/notification_controller");
const auth_1 = require("../middlewares/auth");
const notificationRoutes = (0, express_1.Router)();
notificationRoutes.post('/getNotifications', auth_1.auth, notification_controller_1.getNotificationsForIds);
exports.default = notificationRoutes;
