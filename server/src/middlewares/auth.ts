import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

// Define the type for the JWT payload
interface JwtPayload {
  id: string;
}

// Define a middleware function for authentication
export const auth = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied" });
    }

    const verified = jwt.verify(token, "passwordKey") as JwtPayload; // Type assertion for JWT payload
    if (!verified) {
      return res
        .status(401)
        .json({ msg: "Token verification failed, authorization denied." });
    }

    req.user = verified.id; // Assign the verified user ID to the request object
    req.token = token; // Assign the token to the request object
    next(); // Move to the next middleware
  } catch (err: any) {
    res.status(500).json({ error: err.message });
  }
};

