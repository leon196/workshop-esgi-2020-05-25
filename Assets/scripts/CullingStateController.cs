using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Using lines from Keijiro Takahashi

internal class CullingStateController : MonoBehaviour
{
	public Renderer target { get; set; }

	void OnPreCull()
	{
		target.enabled = true;
	}

	void OnPostRender()
	{
		target.enabled = false;
	}
}