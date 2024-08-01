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
exports.tokenIsValid = exports.loginUser = exports.registerUser = void 0;
const user_1 = __importDefault(require("../models/user"));
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const bcryptjs = require("bcryptjs");
// User registration
const registerUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { name, email, password, address, location } = req.body;
    try {
        const existingUser = yield user_1.default.findOne({ email });
        if (existingUser) {
            return res
                .status(400)
                .json({ msg: "User with same email already exists!" });
        }
        const hashedPassword = yield bcryptjs.hash(password, 10);
        const user = new user_1.default({ name, email, password: hashedPassword, address, location, itemsListed: [], itemsLended: [], itemsBorrowed: [], itemsRequested: [] });
        yield user.save();
        res.status(201).json({ user });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
});
exports.registerUser = registerUser;
const loginUser = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const { email, password } = req.body;
    try {
        const user = yield user_1.default.findOne({ email }).lean(); // Use lean() to get a plain object
        if (!user) {
            return res
                .status(400)
                .json({ msg: "User with this email does not exist!" });
        }
        const isMatch = yield bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ msg: "Incorrect password." });
        }
        const token = jsonwebtoken_1.default.sign({ id: user._id }, "passwordKey");
        res.status(201).json({ token, user });
    }
    catch (error) {
        res.status(400).send({ error: error.message });
    }
});
exports.loginUser = loginUser;
const tokenIsValid = (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    try {
        const token = req.header("x-auth-token");
        if (!token)
            return res.json(false);
        // Verify the token and ensure it's of the expected type
        const verified = jsonwebtoken_1.default.verify(token, "passwordKey");
        // Check if the verified object has the id property
        if (!verified || !verified.id)
            return res.json(false);
        const user = yield user_1.default.findById(verified.id);
        if (!user)
            return res.json(false);
        res.json(true);
    }
    catch (e) {
        res.status(500).json({ error: e.message });
    }
});
exports.tokenIsValid = tokenIsValid;
// export const getUser =  auth, async (req: Request, res: Response)=> {
//   try {
//     if (!req.user) {
//       return res.status(400).json({ msg: "User ID not found in request." });
//     }
//     const user = await User.findById(req.user);
//     if (!user) {
//       return res.status(404).json({ msg: "User not found." });
//     }
//     res.json(user);
//   } catch (error) {
//     res.status(500).json({ error: (error as Error).message });
//   }
// };
