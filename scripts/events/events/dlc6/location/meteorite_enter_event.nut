this.meteorite_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.meteorite_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_154.png[/img]{Un cataclysme tel que le monde le connaît vient de la terre elle-même. Volcans, inondations, tremblements de terre, fléaux, ce sont des choses que tous les hommes craignent. Les évènements imprévues qui peuvent instantanément briser le plus grand des royaumes et enlever la couleur royale du plus grand des rois. La grande caldeira devant vous est un rappel brutal que non seulement vous êtes petits, mais que vous ne savez peut-être même pas à quel point vous êtes petits : il est clair, même pour le plus simple des esprits, que l\'énorme rocher au centre du cratère est venu d\'en haut. Peut-être même de très haut. Les habitants du Nord croient que c\'est un des vestiges de la grande guerre des anciens dieux. Il s\'agit d\'une montagne littéralement armée par les divinités, lancée comme une pierre depuis une catapulte avant d\'atterrir avec des dégâts si apocalyptiques que les horreurs provoquées ont mis fin à tout conflit céleste. Les sudistes la voient comme la larme ardente du doreur. Regardant un monde sans homme, le Dieu tomba dans une profonde tristesse et pleura sur la terre. Au début, il craignait d\'avoir détruit tout ce qui se trouvait en dessous, mais au lieu de cela, il a regardé l\'homme s\'extraire des feux et se revêtir de cendres. Et c\'est alors qu\'Il a su que l\'Homme, vivant aux quatre coins de la terre, était Son élu, et que l\'Homme L\'a connu. Quoi qu\'il en soit, le cratère attire des adeptes et des croyants de toutes les directions. Il existe ici un accord à l\'amiable selon lequel il ne doit pas y avoir d\'impasses entre eux, bien qu\'en période de guerre religieuse, cet accord tacite soit souvent rompu.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Notre destin nous mènera à nouveau ici dans le temps.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

