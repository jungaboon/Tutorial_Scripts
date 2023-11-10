using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WeaponPickup : MonoBehaviour
{
    [SerializeField] private Weapon weapon;
    public Weapon GetWeapon {get {return weapon;} }

    [SerializeField] private Rigidbody rb;

    public Weapon Use()
    {
        Weapon _w = Instantiate(weapon, transform.position, Quaternion.identity);
        Invoke("Destroy", 0.1f);
        return _w;
    }

    public void Spawn(Vector3 dir)
    {
        if(rb) 
        {
            rb.AddForce(dir, ForceMode.Impulse);
            rb.AddTorque(dir,ForceMode.Impulse);
        }
    }

    public void Destroy()
    {
        Destroy(gameObject);
    }
}
