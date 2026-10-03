import os
import sys
import cv2
from rapidocr_onnxruntime import RapidOCR

path = r'C:\Users\shruti_g\AppData\Local\Packages\Microsoft.ScreenSketch_8wekyb3d8bbwe\TempState\Recordings\20261003-0951-39.5083870.mp4'
print('Exists:', os.path.exists(path), 'Size:', os.path.getsize(path) if os.path.exists(path) else 'missing')

cap = cv2.VideoCapture(path)
if not cap.isOpened():
    print('OPEN_FAIL')
    sys.exit(0)

fps = cap.get(cv2.CAP_PROP_FPS)
frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
length = frames / fps if fps > 0 else 0
print('fps=', fps, 'frames=', frames, 'length=', length)
ocr = RapidOCR()
sample_times = [0, 1, 2, 3, 4, 5, 8, 10, 15, 20, 25, 30, 40, 50, 60, 90]
for sec in sample_times:
    if sec > length:
        continue
    cap.set(cv2.CAP_PROP_POS_MSEC, sec * 1000)
    ok, frame = cap.read()
    if not ok:
        continue
    h, w = frame.shape[:2]
    if h > 2000 or w > 2000:
        scale = min(2000 / max(h, w), 1)
        frame = cv2.resize(frame, (int(w * scale), int(h * scale)))
    result, _ = ocr(frame)
    if result:
        text = '\n'.join([r[1] for r in result[:20]])
        print(f'--- SEC {sec} ---')
        print(text[:3000])
        print()
    else:
        print(f'--- SEC {sec} --- NO OCR TEXT')

cap.release()
