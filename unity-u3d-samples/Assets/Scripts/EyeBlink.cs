using UnityEngine;

public class EyeBlink : MonoBehaviour
{
    public Material material;
    //public float rngMin = 1;
    //public float rngMax = 1;
    //public float blinkTime = 1;
    public string v2Property = "_MainTex_ST";
    public Texture eyeOpen;
    public Texture eyeClosed;
    public bool isEyeOpen = true;

    void Update()
    {
        if (material == null)
            return;

        if (isEyeOpen == true)
            material.SetTexture(v2Property, eyeOpen);
        else
            material.SetTexture(v2Property, eyeClosed);
    }
}
