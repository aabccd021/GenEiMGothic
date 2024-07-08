import * as fs from "node:fs";
import { finished } from 'node:stream/promises'
import { Readable } from 'node:stream'

async function download() {
  const res = await fetch("https://okoneya.jp/font/GenEiMGothic_v2.0.zip", {
    "headers": {
      "Referer": "https://okoneya.jp/font/download.html",
      "Referrer-Policy": "strict-origin-when-cross-origin",
      "sec-ch-ua": "\"Not/A)Brand\";v=\"8\", \"Chromium\";v=\"126\", \"Google Chrome\";v=\"126\"",
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": "\"Linux\"",
      "upgrade-insecure-requests": "1",
    },
    "body": null,
    "method": "GET"
  })
  const fileStream = fs.createWriteStream("./fonts.zip");
  await finished(Readable.fromWeb(res.body).pipe(fileStream));
}

void download()
