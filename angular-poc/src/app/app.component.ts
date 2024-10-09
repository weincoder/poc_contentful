import { Component, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { ContentfulService } from './contentful.service';
import { JsonPipe } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, JsonPipe],
  providers: [ContentfulService],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit {
  title = 'contentfull-poc';
  description = '';
  menuPlus = {};
  menuEnterprise = {};
  constructor(private contentfulService: ContentfulService) {}
  ngOnInit(): void {
    this.contentfulService.getProducts().then((products) => {
      this.description = products.description;
      this.menuPlus = products.pricingContent.plus.menu;
      this.menuEnterprise = products.pricingContent["Enterprise "];
    });
  }
}

