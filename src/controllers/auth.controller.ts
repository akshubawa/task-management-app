import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { prisma } from "../utils/prisma";

export const register = async (req: Request, res: Response) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        status: false,
        message: "Email and password are required",
        data: null,
      });
    }

    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return res.status(400).json({
        status: false,
        message: "User already exists",
        data: null,
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
      },
    });

    return res.status(201).json({
      status: true,
      message: "User registered successfully",
      data: {
        user: {
          id: user.id,
          email: user.email,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};



export const login = async (req: Request, res: Response) => {
    const { email, password } = req.body;
  
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!email || !password) {
      return res.status(400).json({
        status: false,
        message: "Email and password are required",
        data: null,
      });
    }
  
    if (!user) {
      return res.status(400).json({
        status: false,
        message: "Invalid credentials",
        data: null,
      });
    }
  
    const isMatch = await bcrypt.compare(password, user.password);
  
    if (!isMatch) {
      return res.status(400).json({
        status: false,
        message: "Invalid credentials",
        data: null,
      });
    }
  
    const accessToken = jwt.sign(
      { userId: user.id },
      process.env.JWT_ACCESS_SECRET!,
      { expiresIn: "1d" }
    );
  
    const refreshToken = jwt.sign(
      { userId: user.id },
      process.env.JWT_REFRESH_SECRET!,
      { expiresIn: "7d" }
    );
  
    await prisma.user.update({
      where: { id: user.id },
      data: { refreshToken },
    });
  
    return res.status(200).json({
      status: true,
      message: "Login successful",
      data: {
        user: {
          id: user.id,
          email: user.email,
        },
        accessToken,
        refreshToken,
      },
    });
  };
  

  export const refreshToken = async (req: Request, res: Response) => {
    const { refreshToken } = req.body;
  
    if (!refreshToken) {
      return res.status(401).json({ message: "Refresh token required" });
    }
  
    const user = await prisma.user.findFirst({
      where: { refreshToken },
    });
  
    if (!user) {
      return res.status(403).json({ message: "Invalid refresh token" });
    }
  
    try {
      const decoded = jwt.verify(
        refreshToken,
        process.env.JWT_REFRESH_SECRET!
      ) as any;
  
      const newAccessToken = jwt.sign(
        { userId: decoded.userId },
        process.env.JWT_ACCESS_SECRET!,
        { expiresIn: "15m" }
      );
  
      res.json({ accessToken: newAccessToken });
    } catch {
      return res.status(403).json({ message: "Invalid or expired refresh token" });
    }
  };

  export const logout = async (req: Request, res: Response) => {
    const { refreshToken } = req.body;
  
    if (!refreshToken) {
      return res.status(400).json({ message: "Refresh token required" });
    }
  
    await prisma.user.updateMany({
      where: { refreshToken },
      data: { refreshToken: null },
    });
  
    res.json({ message: "Logged out successfully" });
  };
  