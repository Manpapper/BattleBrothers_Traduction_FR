this.rangers_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.rangers_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_10.png[/img]Malgré les histoires de chasseurs solitaires affamés qui cherchent juste à nourrir leur famille, les braconniers travaillent souvent en équipe et créent des commerces entiers à partir du commerce de fourrures et de viandes volées.\n\nMais comme votre seigneur local, %noble%, est devenu de plus en plus agacé par les braconniers qui chassent dans ses environs Il ne restait plus que vous, %hunter1%, %hunter2% et %hunter3%, et une décision devait être prise : comment gagner sa vie quand tout ce que vous savez faire, c\'est utiliser un arc ?\n\nIl a été décidé de mettre vos talents collectifs au service du mercenariat, et vous avez été rapidement élu capitaine de la bande.%SPEECH_ON% Vous avez les yeux les plus aiguisés de nous tous.%SPEECH_OFF%%hunter2% dit, et %hunter3% est d\'accord, bien que tempéré.%SPEECH_ON% Et vous êtes, bien sûr, facilement le pire tireur du groupe.%SPEECH_OFF%C Certes, votre joyeuse bande de braconniers apporte des talents uniques à la table - vos hommes préfèrent voyager léger, mais ils sont rapides sur leurs pieds, bons tireurs à l\'arc et experts en repérage pour éviter les engagements défavorables.",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous nous en sortirons bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
				local brothers = this.World.getPlayerRoster().getAll();
				this.Characters.push(brothers[1].getImagePath());
				this.Characters.push(brothers[2].getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "A Band of Poachers";
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local settlements = this.World.EntityManager.getSettlements();
		local closest;
		local distance = 9999;

		foreach( s in settlements )
		{
			local d = s.getTile().getDistanceTo(this.World.State.getPlayer().getTile());

			if (d < distance)
			{
				closest = s;
				distance = d;
			}
		}

		local f = closest.getFactionOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"hunter1",
			brothers[0].getName()
		]);
		_vars.push([
			"hunter2",
			brothers[1].getName()
		]);
		_vars.push([
			"hunter3",
			brothers[2].getName()
		]);
		_vars.push([
			"noble",
			f.getRandomCharacter().getName()
		]);
	}

	function onClear()
	{
	}

});

