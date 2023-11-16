using UnityEngine;
using UnityEngine.Events;

public class WeaponHandler : MonoBehaviour
{
    [SerializeField] private float fireRate = 1f;
    private float fireTime;

    [SerializeField] private UnityEvent onFireEvents;

    private void Update()
    {
        if(Input.GetKeyDown(KeyCode.Mouse0))
        {
            fireTime = 0f;
        }
        if(Input.GetKey(KeyCode.Mouse0))
        {
            if(fireTime > 0f) fireTime -= Time.deltaTime;
            else 
            {
                onFireEvents?.Invoke();
                fireTime = fireRate;
            }
        }
    }
}
