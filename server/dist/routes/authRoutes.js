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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const authController_1 = require("../controllers/authController");
const auth_1 = require("../middlewares/auth");
const user_1 = __importDefault(require("../models/user"));
const authRouter = (0, express_1.Router)();
authRouter.post('/register', authController_1.registerUser);
authRouter.post('/login', authController_1.loginUser);
authRouter.post('/tokenIsValid', authController_1.tokenIsValid);
authRouter.get("/user", auth_1.auth, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        if (!req.user) {
            return res.status(400).json({ msg: "User ID not found in request." });
        }
        const user = yield user_1.default.findById(req.user);
        if (!user) {
            return res.status(404).json({ msg: "User not found." });
        }
        res.json(user);
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
}));
exports.default = authRouter;
