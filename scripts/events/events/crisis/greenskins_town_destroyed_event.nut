this.greenskins_town_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.greenskins_town_destroyed";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_94.png[/img]{De sombres nouvelles sur la route. Des réfugiés et des commerçants signalent que %city% a été détruite par les Peaux-Vertes ! Si cela continue, il n\'y aura nulle part ou retourner, plus de chez soit, quand tout sera dit et fait. | Vous trouvez un noble messager en train d\'abreuver son cheval le long du chemin. Il déclare que les Peaux-Vertes ont anéanti les armées humaines autour de %city% et détruit la ville elle-même ! | Vous tombez sur un cartographe et un commerçant avec un chariot vide. Ils redessinent une carte et il y a quelque chose de curieux à ce sujet : le cartographe efface %city% du papier. Lorsque vous lui demandez pourquoi, il lève un sourcil.%SPEECH_ON%Oh, vous n\'avez pas entendu ? %city% a été détruite. Les Peaux-Vertes ont envahi les défenses et tué tous ceux sur qui ils ont mis la main.%SPEECH_OFF% | Vous croisez un commerçant sur le chemin. Sa charrette est vide et il lui manque quelques animaux de trait. Il y a du sang sur son visage et ses vêtements. Vous demandez à l\'homme son histoire. Il se redresse.%SPEECH_ON%Mon histoire ? Non, ce n\'est pas mon histoire. J\'étais en route pour %city% seulement pour la trouver envahi par les peaux vertes. J\'ai failli y laisser ma vie. La ville elle-même est foutue. Si c\'est dans cette direction que vous vous dirigiez, ne vous embêtez pas. C\'est foutu. Complètement foutu.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Sommes-nous en train de perdre cette guerre ?",
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
		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_greenskins_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("crisis_greenskins_town_destroyed");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});

