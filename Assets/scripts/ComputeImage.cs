using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class ComputeImage : MonoBehaviour
{
	public ComputeShader compute;

	private Material material;
	private RenderTexture texture;


	void Start ()
	{
		material = GetComponent<MeshRenderer>().sharedMaterial;

		texture = new RenderTexture(512, 424, 0);
		texture.enableRandomWrite = true;
		texture.Create();
	}

	void Update ()
	{
		compute.SetTexture(0, "_Texture", texture);
		compute.SetFloat("_Time", Time.time);
		compute.Dispatch(0, texture.width/8, texture.height/8, 1);
		material.SetTexture("_MainTex", texture);
	}
}
