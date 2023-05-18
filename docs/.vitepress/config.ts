import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "SIA - Scalable infrastructure for applications",
  description: "Tutorial de criação de uma infraestrutura escalonável para aplicações na AWS",

  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/leticiacb1/SIA' }
    ]
  }
})
