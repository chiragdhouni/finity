import { Request, Response , RequestHandler} from 'express';
import User from '../models/user';
import jwt, { JwtPayload } from 'jsonwebtoken';

const bcryptjs = require("bcryptjs");
// User registration
export const registerUser = async (req: Request, res: Response) => {
  const {  name, email, password, location } = req.body;
  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 10);
    const user = new User({ name, email, password: hashedPassword, location, itemsLended: [], itemsBorrowed: [], itemsRequested: [] });
    await user.save();
    res.status(201).json({ user });
  } catch (error) {
    res.status(500).json({ error: (error as Error).message });
  }
};


export const loginUser = async (req: Request, res: Response) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email }).lean(); // Use lean() to get a plain object
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.status(201).json({ token, user });

  } catch (error) {
    res.status(400).send({ error: (error as Error).message });
  }
};


// Define an interface for the expected JWT payload
interface MyJwtPayload extends JwtPayload {
  id: string;
}

export const tokenIsValid = async (req: Request, res: Response) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    // Verify the token and ensure it's of the expected type
    const verified = jwt.verify(token, "passwordKey") as MyJwtPayload;

    // Check if the verified object has the id property
    if (!verified || !verified.id) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);

    res.json(true);
  } catch (e) {
    res.status(500).json({ error: (e as Error).message });
  }
};
// Extend the Request interface globally to include user and token
declare global {
  namespace Express {
    interface Request {
      user?: string; // Assuming user ID is a string
      token?: string;
    }
  }
}

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



