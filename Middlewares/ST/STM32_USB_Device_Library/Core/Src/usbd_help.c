
#include "usbd_help.h"
#include <stddef.h>
#include "usbd_def.h"
/**
  * @brief  USBD_GetEpDesc
  *         This function return the Endpoint descriptor
  * @param  pdev: device instance
  * @param  pConfDesc:  pointer to Bos descriptor
  * @param  EpAddr:  endpoint address
  * @retval pointer to video endpoint descriptor
  */
void *USBD_GetEpDesc(uint8_t *pConfDesc, uint8_t EpAddr)
{
  USBD_DescHeaderTypeDef *pdesc = (USBD_DescHeaderTypeDef *)(void *)pConfDesc;
  USBD_ConfigDescTypeDef *desc = (USBD_ConfigDescTypeDef *)(void *)pConfDesc;
  USBD_EpDescTypeDef *pEpDesc = NULL;
  uint16_t ptr;

  if (desc->wTotalLength > desc->bLength)
  {
    ptr = desc->bLength;

    while (ptr < desc->wTotalLength)
    {
      pdesc = USBD_GetNextDesc((uint8_t *)pdesc, &ptr);

      if (pdesc->bDescriptorType == USB_DESC_TYPE_ENDPOINT)
      {
        pEpDesc = (USBD_EpDescTypeDef *)(void *)pdesc;

        if (pEpDesc->bEndpointAddress == EpAddr)
        {
          break;
        }
        else
        {
          pEpDesc = NULL;
        }
      }
    }
  }

  return (void *)pEpDesc;
}


/**
  * @brief  USBD_GetNextDesc
  *         This function return the next descriptor header
  * @param  buf: Buffer where the descriptor is available
  * @param  ptr: data pointer inside the descriptor
  * @retval next header
  */
USBD_DescHeaderTypeDef *USBD_GetNextDesc(uint8_t *pbuf, uint16_t *ptr)
{
  USBD_DescHeaderTypeDef *pnext = (USBD_DescHeaderTypeDef *)(void *)pbuf;

  *ptr += pnext->bLength;
  pnext = (USBD_DescHeaderTypeDef *)(void *)(pbuf + pnext->bLength);

  return (pnext);
}
#if 0
void usbd_set_desc(uint8_t *pConfDesc, uint8_t inAddr , uint8_t outAddr)
{
    USBD_EpDescTypeDef* pEpinDesc  = USBD_GetEpDesc(pConfDesc, inAddr);
    USBD_EpDescTypeDef* pEpoutDesc = USBD_GetEpDesc(pConfDesc, outAddr);

    if(pEpinDesc != NULL) {
      pEpinDesc->bmAttributes = 0x03;
      pEpinDesc->wMaxPacketSize = CUSTOM_HID_EPIN_SIZE;
      pEpinDesc->bInterval = CUSTOM_HID_FS_BINTERVAL;
    }

    if(pEpoutDesc != NULL) {
      pEpoutDesc->bmAttributes = 0x03;
      pEpoutDesc->wMaxPacketSize = CUSTOM_HID_EPOUT_SIZE;
      pEpoutDesc->bInterval = CUSTOM_HID_FS_BINTERVAL;
    }
}

#endif
