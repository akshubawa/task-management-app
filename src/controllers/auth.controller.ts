import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { prisma } from "../utils/prisma";
import { registerSchema, loginSchema } from "../validators/auth.validator";


export const register = async (req: Request, res: Response) => {
  try {
    const parsed = registerSchema.safeParse(req.body);

    if (!parsed.success) {
      return res.status(400).json({
        status: false,
        message: parsed.error.issues[0].message,
        data: null,
      });
    }

    const { fullName, email, mobileNumber, password } = parsed.data;

    const existingUser = await prisma.user.findFirst({
      where: {
        OR: [{ email }, { mobileNumber }],
      },
    });

    if (existingUser) {
      return res.status(400).json({
        status: false,
        message: "Email or mobile number already registered",
        data: null,
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await prisma.user.create({
      data: {
        fullName,
        email,
        mobileNumber,
        password: hashedPassword,
      },
    });

    return res.status(201).json({
      status: true,
      message: "User registered successfully",
      data: {
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        mobileNumber: user.mobileNumber,
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
  try {
    const parsed = loginSchema.safeParse(req.body);

    if (!parsed.success) {
      return res.status(400).json({
        status: false,
        message: parsed.error.issues[0].message,
        data: null,
      });
    }

    const { email, password } = parsed.data;

    const user = await prisma.user.findUnique({
      where: { email },
    });

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
          fullName: user.fullName,
          email: user.email,
          mobileNumber: user.mobileNumber,
        },
        accessToken,
        refreshToken,
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


export const getProfile = async (req: any, res: Response) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.userId },
      select: {
        id: true,
        fullName: true,
        email: true,
        mobileNumber: true,
        createdAt: true,
      },
    });

    if (!user) {
      return res.status(404).json({
        status: false,
        message: "User not found",
        data: null,
      });
    }

    return res.status(200).json({
      status: true,
      message: "Profile fetched successfully",
      data: user,
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      data: null,
    });
  }
};
  
  