this.noble_more_pay_lowborn_event <- this.inherit("scripts/events/event", {
	m = {
		Noble = null,
		Lowborn = null
	},
	function create()
	{
		this.m.ID = "event.noble_more_pay_lowborn";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img] %noble% entre soudainement dans votre tente. Il est vêtu d\'une armure et son arme est à son côté. On dirait presque qu\'il s\'est habillé pour l\'occasion, et il se tient en effet droit et correctement. Vous lui demandez ce qu\'il veut, et il vous répond en gardant la tête haute et en regardant droit devant lui.%SPEECH_ON%Il a été porté à mon attention que %lowborn% est mieux payé que moi. Bien que je n\'aie aucun problème avec cet homme personnellement, je tiens à souligner que c\'est un homme qui n\'a droit à rien d\'autre qu\'à ses deux pieds. Il est impossible qu\'un homme de basse naissance soit mieux payé qu\'un homme de la haute société. Nous, les nobles, méritons mieux.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je veillerai à ce que vous ne soyez pas moins bien payé que lui.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Nous payons en fonction de l\'expériences et des compétences, pas en fonction de la lignée.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Et si on diminuait votre salaire à la place ?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				this.Characters.push(_event.m.Lowborn.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous n\'êtes pas nécessairement d\'accord avec lui, mais en même temps, vous voyez bien que refuser cette demande pourrait causer des problèmes inédits. En quelques traits de plume sur le parchemin de la liste, vous attribuez à %noble% un salaire plus élevé et lui dites de s\'attendre à une bourse plus lourde lors de la prochaine paie. L\'homme vous regarde enfin et s\'incline à partir de la taille. %SPEECH_ON%Vous avez pris la bonne décision. %SPEECH_OFF%Il tourne les talons et repart avec autant d\'entrain qu\'il est entré.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "L\'égalité des salaires maintiendra la paix.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage += this.Math.max(0, _event.m.Lowborn.getDailyCost() - _event.m.Noble.getDailyCost());
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " est maintenant payé " + _event.m.Noble.getDailyCost() + " Couronnes par jour"
				});
				_event.m.Noble.improveMood(1.0, "A eu une augmentation de salaire");

				if (_event.m.Noble.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous dites à l\'homme de vous regarder. Il déplace lentement ses yeux vers les vôtres. Maintenant que vous avez son attention, vous expliquez les règles ici.%SPEECH_ON%Je paie en fonction de l\'expérience et des compétences, pas en fonction de ce que vous étiez avant de signer. Vous pourriez être un éleveur de chèvres, si vous pouvez manier l\'épée, vous serez payé, et si vous pouvez le faire mieux que votre voisin, que je sois damné, vous serez payé plus que votre voisin ! Il y a quelque chose que tu n\'as pas compris ?%SPEECH_OFF% Les joues de %noble% frémissent alors qu\'il est pris d\'un soudain accès de rage. Il parle à travers ses dents serrées. %SPEECH_ON% Non, monsieur.%SPEECH_OFF% D\'un geste du poignet, vous lui dites de disparaître de votre vue. Il s\'en va précipitamment, sa posture droite se transformant en une attitude bougonne.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Si tu veux avoir plus de couronnes, mérite-les.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.worsenMood(2.0, "On lui a refusé sa supériorité par rapport à une personne de basse lignée.");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_64.png[/img]Vous vous levez de votre chaise et vous criez à l\'homme de vous regarder. Il fait ce qu\'on lui dit et vous lui expliquez ce qui va se passer.%SPEECH_ON%%lowborn% s\'est fait une place dans ce monde en se traînant hors de la boue. Vous êtes né avec une cuillère en argent, mais ce n\'est pas ici que vous êtes né, n\'est-ce pas ? Donc à partir d\'aujourd\'hui, considérez que votre salaire a effectivement baissé. Vous voulez avoir droit à un meilleur salaire ? Mérite-le.%SPEECH_OFF% La position du noble vacille. Il ouvre la bouche, mais vous levez rapidement la main.%SPEECH_ON%Pas un mot. Hors de ma vue.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vas-t\'en!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Noble.getImagePath());
				_event.m.Noble.getBaseProperties().DailyWage -= _event.m.Noble.getDailyCost() / 2;
				_event.m.Noble.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Noble.getName() + " est maintenant payé " + _event.m.Noble.getDailyCost() + " Couronnes par jour"
				});
				_event.m.Noble.worsenMood(2.0, "A été humilié par le capitaine");
				_event.m.Noble.worsenMood(2.0, "On lui a refusé sa supériorité par rapport à une personne de basse lignée.");
				_event.m.Noble.worsenMood(2.0, "A eu une réduction de salaire");

				if (_event.m.Noble.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Noble.getMoodState()],
						text = _event.m.Noble.getName() + this.Const.MoodStateEvent[_event.m.Noble.getMoodState()]
					});
				}

				if (!_event.m.Noble.getSkills().hasSkill("trait.greedy"))
				{
					local trait = this.new("scripts/skills/traits/greedy_trait");
					_event.m.Noble.getSkills().add(trait);
					this.List.push({
						id = 10,
						icon = trait.getIcon(),
						text = _event.m.Noble.getName() + " devient cupide"
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getMoney() < 500)
		{
			return;
		}

		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local lowestPay = 1000;
		local lowestNoble;

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() < lowestPay && bro.getBackground().isNoble())
			{
				lowestNoble = bro;
				lowestPay = bro.getDailyCost();
			}
		}

		if (lowestNoble == null)
		{
			return;
		}

		local lowborn_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getDailyCost() > lowestPay && bro.getBackground().isLowborn())
			{
				lowborn_candidates.push(bro);
			}
		}

		if (lowborn_candidates.len() == 0)
		{
			return;
		}

		this.m.Noble = lowestNoble;
		this.m.Lowborn = lowborn_candidates[this.Math.rand(0, lowborn_candidates.len() - 1)];
		this.m.Score = 7 + (lowestNoble.getSkills().hasSkill("trait.greedy") ? 9 : 0);
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"noble",
			this.m.Noble.getName()
		]);
		_vars.push([
			"lowborn",
			this.m.Lowborn.getName()
		]);
	}

	function onClear()
	{
		this.m.Noble = null;
		this.m.Lowborn = null;
	}

});

