import { Injectable } from '@angular/core';
import { createClient } from 'contentful';
import { environment } from '../environments/environment.development';
@Injectable({
  providedIn: 'root'
})
export class ContentfulService {
  private cdaClient = createClient({
    space: environment.contentful.space,
    accessToken: environment.contentful.accessToken
  });

  constructor() { }

  getProducts(query?: object): Promise<any> {
    return this.cdaClient.getEntries(Object.assign({
      content_type: environment.contentful.contentType
    }, query))
    .then(res => res['items'][0].fields);
  }
}
