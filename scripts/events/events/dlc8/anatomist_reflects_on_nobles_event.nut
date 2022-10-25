this.anatomist_reflects_on_nobles_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_reflects_on_nobles";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_39.png[/img]{%anatomist% l\'anatomiste est assis près du feu de camp. Il semble plongé dans ses pensées. Comme vous êtes un peu un connard, vous pensez que c\'est le moment idéal pour passer le voir et commencer à lui poser des questions, en particulier la question la plus ennuyeuse qu\'il puisse exister: \"À quoi pensez-vous?\". L\'anatomiste se frotte les yeux et pousse un long soupir. Il dit,%SPEECH_ON%Je réfléchis à la nature des entités de ce monde, notamment celles qui se trouvent le plus haut et le plus bas. Comprends, vaurien, que nous avons rencontré un certain nombre de membres de la famille royale au cours de nos voyages et que l\'impression qu\'ils m\'ont laissée est une grande désillusion. Les animaux sauvages fonctionnent sur une base équitable, de sorte que celui qui mange et celui qui se retrouve à pleurnicher pour des miettes, sont délimités par le talent pur. L\'axiome selon lequel être le meilleur permet de s\'élever au sommet n\'est-il axiomatique que dans le monde des animaux? J\'ai considéré comme une vérité que nos gouvernants, et maintenant nos bienfaiteurs, reflètent ces réalités. Au lieu de cela, je suis confronté, encore et encore, à des bouffons. Des incompétents dont les principaux talents consistent à équilibrer les indulgences, trop et les paysans sont irrités par les extravagances, trop peu et les laïcs pensent que leurs dirigeants gaspillent à mauvais escient leur place de privilégiés. Mon jugement sur mes semblables diminue chaque jour. Oserais-je dire, oserais-je dire, vaurien...vaurien, m\'écoutez-vous?%SPEECH_OFF%Vous êtes en train de faire tourner un bâton dans le feu quand vous entendez votre nom de famille. En jetant un coup d\'œil, vous lui dites que vous n\'êtes pas étranger à ces pensées, mais qu\'elles sont juste: Des pensées. Malgré la pression de votre environnement, vous assumez toujours ce que vous pensez. Si ça le dérange tant, il devrait simplement mettre ça de côté. Il n\'a aucun contrôle sur le monde, après tout, et cette façon de penser ne favorisera pas un changement plus important. Ce ne sont que des jérémiades. L\'anatomiste vous regarde fixement. Il acquiesce.%SPEECH_ON%Je pense qu\'il est bon que je ne m\'attarde pas sur ces choses, car leurs erreurs n\'ont pas été faites par ma main, et ce n\'est pas par ma main qu\'elles pourront jamais être réparées.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est ça l\'esprit.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local resolve_boost = this.Math.rand(2, 4);
				_event.m.Anatomist.getBaseProperties().Bravery += resolve_boost;
				_event.m.Anatomist.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Anatomist.getName() + " gains [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + resolve_boost + "[/color] Resolve"
				});
				_event.m.Anatomist.improveMood(1.0, "Better understands the limits of his volition");

				if (_event.m.Anatomist.getMoodState() > this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Anatomist.getMoodState()],
						text = _event.m.Anatomist.getName() + this.Const.MoodStateEvent[_event.m.Anatomist.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Assets.getBusinessReputation() < 1500)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomist_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist")
			{
				anatomist_candidates.push(bro);
			}
		}

		if (anatomist_candidates.len() == 0)
		{
			return;
		}

		this.m.Anatomist = anatomist_candidates[this.Math.rand(0, anatomist_candidates.len() - 1)];
		this.m.Score = 3 * anatomist_candidates.len();
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
	}

});

