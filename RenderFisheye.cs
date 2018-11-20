// Copyright Massachusetts Institute of Technology 2018

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class RenderFisheye : MonoBehaviour {
    public RenderCubemap cubemap_script;
    public Shader shader;
    public float alpha = 4.0f;
    public float chi = 0.0f;
    public float focalLength = 1.0f;

    private Material _material;
    private Material material {
        get {
            if (_material == null) {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        }
    }

    void Start () {
    }

    private void OnDisable() {
        if (_material != null)
            DestroyImmediate(_material);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
	   Debug.Log("OnRenderImage: Fisheye");
       if (shader != null) {
       	   material.SetTexture("_Cube", cubemap_script.cubemap);
       	   material.SetFloat("_Alpha", alpha);
       	   material.SetFloat("_Chi", chi);
       	   material.SetFloat("_FocalLength", focalLength);
           Graphics.Blit(source, destination, material);
       } else {
           Graphics.Blit(source, destination);
       }
    }
}
