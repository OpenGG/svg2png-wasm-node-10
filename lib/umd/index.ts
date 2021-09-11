import init, { createConverter, InitOutput } from '../../pkg-umd/svg2png_wasm';

let wasm: InitOutput | undefined;

export type ConvertOptions = {
  scale?: number;
  width?: number;
  height?: number;
  fonts?: Uint8Array[];
};

export const svg2png = async (svg: string, opts?: ConvertOptions) => {
  if (wasm === undefined) wasm = await init(process.env.SVG2PNG_WASM_URL);
  const converter = createConverter();
  opts?.fonts?.forEach((f) => converter.registerFont(f));
  const result = converter.convert(svg, opts?.scale, opts?.width, opts?.height);
  converter.free();
  return result;
};
