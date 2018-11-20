// Copyright Massachusetts Institute of Technology 2018

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class RenderCubemap : MonoBehaviour {
    public RenderTexture cubemap;
    public int resolution = 1024;

    void Initialize() {
      if(cubemap == null) {
        cubemap = new RenderTexture(resolution, resolution, 24);
        cubemap.dimension = TextureDimension.Cube;
      }
    }
    
    void Awake () {
      Initialize();
    }

    void LateUpdate () {
          Camera cam = GetComponent<Camera>();
          cam.RenderToCubemap(cubemap, 63, Camera.MonoOrStereoscopicEye.Mono);
    }
    
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
       Graphics.Blit(source, destination);
    }

}
