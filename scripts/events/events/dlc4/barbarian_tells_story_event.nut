this.barbarian_tells_story_event <- this.inherit("scripts/events/event", {
	m = {
		Barbarian = null
	},
	function create()
	{
		this.m.ID = "event.barbarian_tells_story";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 30.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]{%barbare% partage autour du feu de camp des récits d'héroïsme et de monstres nordiques. Il n'y a pas grand-chose à dire sur ses dialogues, puisqu'il n'est pas des plus éloquents, mais il s'en sort très bien en mimant et en dessinant dans le sol. {L'une des histoires semble être celle d'un énorme guerrier battant un guerrier encore plus grand, ou peut-être même un ogre. C'est difficile à dire, mais le barbare fait une fascinante démonstration de combat que les hommes applaudissent. | L'un des récits est celui de deux amants, et avec une grande utilisation de ses mains, il fait une démonstration fascinante de ce que c'est que de labourer et d'être labouré. Et, apparemment, ce que c'est que d'être trahi et poignardé dans le dos. On ne sait pas exactement qui poignarde qui, ni quand, ni dans quel sens, mais l'histoire tient les hommes en haleine et se termine par des applaudissements. | Un conte parle d'un unhold amical. Les hommes halètent à cette idée, mais le barbare se tape les poignets et agite le doigt. Vous supposez que c'est sa façon de vous dire que tout est vrai, chaque mot ou grognement. L'idée d'un monstre amical déstabilise les hommes au début, mais à la fin de l'histoire, ils applaudissent et hochent la tête comme s'ils souhaitaient que ce soit vraiment la vérité.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Captivant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Barbarian.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "S'est amusé");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.barbarian")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Barbarian = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"barbarian",
			this.m.Barbarian.getName()
		]);
	}

	function onClear()
	{
		this.m.Barbarian = null;
	}

});

