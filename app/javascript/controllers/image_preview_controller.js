// app/javascript/controllers/image_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    console.log("Image preview controller connected")
  }

  preview() {
    const previewContainer = document.getElementById('image-previews')
    previewContainer.innerHTML = ''

    Array.from(this.inputTarget.files).forEach(file => {
      const reader = new FileReader()
      reader.onload = (e) => {
        const preview = document.createElement('div')
        preview.className = 'relative aspect-square'
        
        const img = document.createElement('img')
        img.src = e.target.result
        img.className = 'w-full h-full object-cover rounded-lg'

        preview.appendChild(img)
        previewContainer.appendChild(preview)
      }
      reader.readAsDataURL(file)
    })
  }
}