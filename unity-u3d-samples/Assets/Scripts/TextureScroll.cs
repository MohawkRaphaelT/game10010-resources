using UnityEngine;

public class TextureScroll : MonoBehaviour
{
    public Material material;
    public float speed = 1;
    public string v2Property = "_MainTex_ST";

    void Update()
    {
        if (material == null)
            return;

        Vector2 value = new(Time.time * speed, 0);
        material.SetVector(v2Property, value);
    }
}
