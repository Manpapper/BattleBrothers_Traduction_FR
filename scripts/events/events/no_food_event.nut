this.no_food_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.no_food";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]{Les stocks de nourriture sont épuisés ! Malgré les horreurs de ce monde, la compagnie %companyname% ne peut pas engager une compagnie de squelettes ! Vous devez apporter de la nourriture aux hommes avant qu\'ils ne partent. | Même le plus loyal des hommes ne peut tenir que cinq ou six repas manqués. Après cela, tout le monde est susceptible de partir pour se nourrir. Procurez-vous de la nourriture - et faites-le vite avant que la compagnie ne s\'effondre ! | Vous avez mal évalué les réserves de nourriture et placé la compagnie %companyname% dans un danger unique - celui d\'avoir faim. Même la plus mortelle des compagnies s\'effondrerait en quelques jours si elle n\'est pas nourrie et cette compagnie ne sera pas différente si vous ne changez pas les choses rapidement !}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je dois donner aux hommes quelque chose à manger.",
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
		if (this.World.Assets.getFood() > 0)
		{
			return;
		}

		this.m.Score = 150;
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

