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
const express_1 = require("express");
const authController_1 = require("../controllers/authController");
const auth_1 = require("../middlewares/auth");
const authRouter = (0, express_1.Router)();
authRouter.post('/register', authController_1.registerUser);
authRouter.post('/login', authController_1.loginUser);
authRouter.get('/tokenIsValid', authController_1.tokenIsValid);
authRouter.patch('/:userId/location', authController_1.updateUserLocation);
authRouter.get("/user", auth_1.auth, (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        // Since req.user now contains the full user object
        const user = req.user;
        if (!user) {
            return res.status(404).json({ msg: "User not found." });
        }
        // Retrieve the token from the request header
        const token = req.header('x-auth-token');
        // Add the token to the response object
        res.status(200).json({ token, user });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
}));
exports.default = authRouter;
