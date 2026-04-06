import { z } from 'zod';

// ── AppConfig (Type) ──
export interface AppConfig {
}

// ── AppConfig (Schema) ──
export const AppConfigSchema: z.ZodType<AppConfig> = z.object({
});