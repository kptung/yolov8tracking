###########################
#           use yolov8 streaming          #
#           without cv2.capture             # 
###########################
import cv2
import os
from ultralytics import YOLO
from absl import app, flags, logging
from absl.flags import FLAGS
flags.DEFINE_string('mtype','detection','detection[DEFAULT]/segmentation/classification/pose')
flags.DEFINE_string('det', 'yolov8n.pt','(detection Fast=>Slow: yolov8n.pt[DEFAULT], yolov8s.pt, yolov8m.pt, yolov8l.pt, yolov8x.pt)')
flags.DEFINE_string('seg', 'yolov8n-seg.pt','(segmentation Fast=>Slow: yolov8n-seg.pt[DEFAULT], yolov8s-seg.pt, yolov8m-seg.pt, yolov8l-seg.pt, yolov8x-seg.pt)')
flags.DEFINE_string('cls', 'yolov8n-cls.pt','(classificationFast=>Slow: yolov8n-cls.pt[DEFAULT], yolov8s-cls.pt, yolov8m-cls.pt, yolov8l-cls.pt, yolov8x-cls.pt)')
flags.DEFINE_string('pose', 'yolov8n-pose.pt','(pose Fast=>Slow: yolov8n-pose.pt[DEFAULT], yolov8s-pose.pt, yolov8m-pose.pt, yolov8l-pose.pt, yolov8x-pose.pt, yolov8x-pose-p6.pt)')
flags.DEFINE_string('video', '0', 'path to input video(incl. YouTube i.e. https://youtu.be/Zgi9g1ksQHc RTSP i.e. rtsp://example.com/media.mp4, RTMP, HTTP) or set to 0 for webcam')
flags.DEFINE_boolean('stream', True, 'a memory-efficient generator of Results objects when using the streaming mode')
flags.DEFINE_float('conf', 0.4, 'object confidence threshold for detection')
flags.DEFINE_integer('imgsz', 320, 'image size')
flags.DEFINE_boolean('show', False, 'integrated show')

def main(_argv):
    mname = FLAGS.det
    if FLAGS.mtype=="segmentation":
        mname = FLAGS.seg
    elif FLAGS.mtype=="classification":
        mname = FLAGS.cls
    elif FLAGS.mtype=="pose":
        mname = FLAGS.pose
    
    # set model
    mname = os.path.join(os.getcwd(),'models',mname)
    model = YOLO(mname)
        
    # Run YOLOv8 inference on the frame
    results = model.predict(source=FLAGS.video, conf=FLAGS.conf, stream=FLAGS.stream, imgsz=FLAGS.imgsz, show=False)
    for r in results:
        r_plotted = r.plot()
        cv2.namedWindow("result", cv2.WINDOW_NORMAL)
        cv2.imshow("result", r_plotted)
        #boxes = r.boxes  # Boxes object for bbox outputs
        #masks = r.masks  # Masks object for segment masks outputs
        #probs = r.probs  # Class probabilities for classification outputs
            
if __name__ == '__main__':
    try:
        app.run(main)
    except SystemExit:
        pass