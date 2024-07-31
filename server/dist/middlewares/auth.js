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
// Define a middleware function for authentication
const auth = (req, res, next) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header("x-auth-token");
        if (!token) {
            return res.status(401).json({ msg: "No auth token, access denied" });
        }
        const verified = jsonwebtoken_1.default.verify(token, "passwordKey"); // Type assertion for JWT payload
        if (!verified) {
            return res
                .status(401)
                .json({ msg: "Token verification failed, authorization denied." });
        }
        req.user = verified.id; // Assign the verified user ID to the request object
        req.token = token; // Assign the token to the request object
        next(); // Move to the next middleware
    }
    catch (err) {
        res.status(500).json({ error: err.message });
    }
});
exports.auth = auth;
