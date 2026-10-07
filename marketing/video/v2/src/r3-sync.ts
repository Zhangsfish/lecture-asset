import data from "../R3_CAPTION_SYNC.json";
export type Caption = {id:string;lines:string[];start:number;end:number;kind:string;source:string;line_times:number[]};
export type LocaleSync = {duration:number;frames:number;end_card:number;mix:string;knots:number[][];captions:Caption[];review_frames:number[];hero_frames:number[];handoff_frames:number[];report_ready:number;report_start:number;saved_full:number;departure_start:number;influx_complete:number;middle_start:number;middle_end:number};
export const sync=data as unknown as {locales:Record<string,LocaleSync>};
