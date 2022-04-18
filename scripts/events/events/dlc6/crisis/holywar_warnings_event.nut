this.holywar_warnings_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holy_warnings";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 3.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Un paysan vous croise sur le chemin. Il mentionne en passant qu\'il ne comprend pas pourquoi les dieux voudraient que leurs fidèles se battent entre eux. Si le problème devait vraiment être réglé, pourquoi ne pas le faire eux-mêmes ? Vous l\'attrapez par la chemise et lui demandez ce qu\'il raconte. Il s\'éloigne. Hé ! Bas les pattes, ou je te mord ! Et je suis juste en train de râler, tout ça. On parle beaucoup du peuple doré et des adeptes des anciens dieux qui s\'affrontent. Encore une fois. Maintenant, laissez-moi râler en paix !%SPEECH_OFF%L\'homme s\'en va en marmonnant et, ironiquement, en augmentant le volume à mesure qu\'il s\'éloigne de vous. | Tu tombes sur un congrès de moines dorés et de moines anciens. Ils discutent de l\'éventualité d\'une guerre à venir et de la manière de se protéger si un tel événement se produit. C\'est admirablement amical, tout compte fait, mais il semble qu\'il y ait un soupçon de décision religieuse dans l\'air. | Un homme qui répare un chariot au bord de la route secoue la tête. Vous savez, j\'aimerais juste aller d\'un endroit du monde à l\'autre, et c\'est tout. Mais non. Merde il y a toujours... quelque chose ! Toujours quelque chose ! Ca doit mal se passer. Hé, en parlant de roue, j\'en entends une qui tourne : le Gilder et les anciens dieux pourraient bien s\'affronter à nouveau. J\'en ai vu des nuages d\'orage. Guerre sainte dans le ciel. Ce qui veut dire guerre sainte ici. J\'espère m\'en éloigner avant qu\'elle ne commence. Vous avez vu le dernier ? Sale affaire.%SPEECH_OFF%Pour sur que ça l\'est, mais sale affaire signifie bonne affaire pour le %companyname%. | Vous regardez pour voir un vieil homme qui remue deux moignons. Il sourit. %SPEECH_ON%C\'est-à-dire que l\'esprit de mon genou devient méchant. Quand j\'avais des jambes, l\'élancement du genou signifiait le mauvais temps. Maintenant, l\'élancement du genou signifie quelque chose de pire.%SPEECH_OFF%Un jeune garçon arrive et tire l\'aîné dans une brouette. Avant qu\'il ne parte, vous lui demandez ce qu\'il veut dire. Il se tourne sur le côté, le coude en avant et la main posée sur sa main, l\'air pimpant et vif pour ce qu\'il est.%SPEECH_ON%Une décision venue d\'en haut. Le Donneur, Les Doreurs, les anciens dieux, peut-être même plus qu\'eux. Je pense qu\'ils jouent tous avec nous, nous incitant à nous entre-tuer pour les apaiser, afin qu\'ils puissent surveiller. Vous avez l\'air d\'un vendeur, donc j\'imagine que les affaires seront gentilles avec vous une fois que les couleurs cléricales voudront passer au rouge.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon à savoir.",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.FactionManager.getGreaterEvilType() == this.Const.World.GreaterEvilType.HolyWar && this.World.FactionManager.getGreaterEvilPhase() == this.Const.World.GreaterEvilPhase.Warning)
		{
			local playerTile = this.World.State.getPlayer().getTile();
			local towns = this.World.EntityManager.getSettlements();

			foreach( t in towns )
			{
				if (t.getTile().getDistanceTo(playerTile) <= 4)
				{
					return;
				}
			}

			this.m.Score = 80;
		}
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

