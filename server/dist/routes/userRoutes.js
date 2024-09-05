"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const auth_1 = require("../middlewares/auth");
const userController_1 = require("../controllers/userController");
const userRouter = (0, express_1.Router)();
userRouter.get('/getUserById', auth_1.auth, userController_1.getUserById);
exports.default = userRouter;
