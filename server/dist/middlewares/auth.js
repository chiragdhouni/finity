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
exports.auth = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const user_1 = __importDefault(require("../models/user")); // Adjust the import according to your project structure
const auth = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header('x-auth-token');
        if (!token) {
            console.log('No token provided');
            return res.status(401).json({ msg: 'No auth token, access denied' });
        }
        const verified = jsonwebtoken_1.default.verify(token, 'passwordKey');
        if (!verified) {
            console.log('Token verification failed');
            return res.status(401).json({ msg: 'Token verification failed, authorization denied.' });
        }
        const user = yield user_1.default.findById(verified.id).exec();
        if (!user) {
            console.log('User not found for ID:', verified.id);
            return res.status(401).json({ msg: 'User not found' });
        }
        req.user = user;
        req.token = token;
        next();
    }
    catch (err) {
        console.log('Middleware Error:', err.message);
        res.status(500).json({ error: err.message });
    }
});
exports.auth = auth;
